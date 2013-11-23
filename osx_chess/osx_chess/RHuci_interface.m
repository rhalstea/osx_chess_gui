/*
    Copyright (c) 2013, Robert J. Halstead
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
 
    *   Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
 
    *   Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in
        the documentation and/or other materials provided with the
        distribution.
 
    *   Neither the name of the Robert J. Halstead nor the names of its
        contributors may be used to endorse or promote products derived
        from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "RHuci_interface.h"

@implementation RHuci_interface

- (void)insert_message:(id) message {
    @try {
        [_terminal setEditable:YES];
        [_terminal insertText:message];
        [_terminal insertText:@"\n"];
        [_terminal setEditable:NO];
    }
    @catch (NSException *e) {
        NSLog(@"ERROR: %@", e);
    }
}

- (id)init:(NSTextView *)terminal {
    _terminal   = terminal;
    _is_ready   = false;
    
    // Setup a listner which will receive position updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analize_position:)
                                                 name:@"position_update"
                                               object:nil];
    return self;
}

- (bool) is_command:(NSString*) str :(NSString*) cmd {
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    return [array[0] isEqualToString:cmd];
}

- (void) handle_output_line:(NSString *)line {
    if ([line length] == 0) {
        return;
    }
    else if ([line isEqualToString:@"uciok"]) {
        _is_ready = true;
    }
    else if ([self is_command:line :@"id"]) {
        NSLog(@"id: %@", line);
    }
    else if ([self is_command:line :@"option"]) {
        NSLog(@"option: %@", line);
    }
    else if ([self is_command:line :@"bestmove"]) {
        //[self insert_message:line];
        NSLog(@"bestmove: %@", line);
    }
    else if (_is_ready) { // only accept unrecognized commands after ready signal
        NSLog(@"Unrecognized command: '%@'", line);
    }
}

- (void) monitor_engine_output {
    NSData *data = nil;
    
    while (true) {
        data = [_out_stream availableData];
        
        if ([data length] == 0)
            continue;
        
        // otherwise read the output
        NSString *output = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
        NSArray *lines = [output componentsSeparatedByString:@"\n"];
        
        for (NSString *l in lines)
            [self handle_output_line:l];
    }
}

- (void)start_engine:(NSPort*) param {
    _is_ready       = false;
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/Users/rhalstea/projects/osx_chess_gui/stockfish-231-mac/src/stockfish"];
    
    NSPipe *outPipe =[NSPipe pipe];
    [task setStandardOutput:outPipe];
    
    NSPipe *inPipe = [NSPipe pipe];
    [task setStandardInput:inPipe];

    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardError:errorPipe];
    
    _out_stream = [outPipe fileHandleForReading];
    _in_stream  = [inPipe fileHandleForWriting];
    _err_stream = [errorPipe fileHandleForReading];
    
    [task launch];
    
    [self send_uci_request];
    [self monitor_engine_output];
    
    [task waitUntilExit];
    NSLog(@"END engine");
}

- (void) send_uci_request {
    NSString    *cmd    = @"uci\n\r";
    NSData      *data   = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    [_in_stream writeData:data];
}

- (void) send_ready_request {
    NSString    *cmd    = @"isready\n\r";
    NSData      *data   = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    [_in_stream writeData:data];
}

- (bool) is_ready {
    return _is_ready;
}

- (void)analize_position: (NSNotification *) notice {
    NSDictionary *info = notice.userInfo;
    NSString *pos = [info objectForKey:@"position"];
    
    if (pos) {
        NSMutableString *cmd = [[NSMutableString alloc] init];
        [cmd appendString:@"stop\nposition fen "];
        [cmd appendString:pos];
        [cmd appendString:@"\n"];
        [_in_stream writeData:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
        
        cmd = [[NSMutableString alloc] init];
        [cmd appendString:@"go infinite\n"];
        [_in_stream writeData:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
