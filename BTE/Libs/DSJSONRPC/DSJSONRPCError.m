/*
 * DSJSONRPC.h
 *
 * Demiurgic JSON-RPC
 * Created by Derek Bowen on 10/20/2011.
 * 
 * Copyright (c) 2011 Demiurgic Software, LLC
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "DSJSONRPCError.h"

@implementation DSJSONRPCError

@synthesize code, message, data;

- (id)initWithErrorData:(NSDictionary *)errorData {
    if (!(self = [super init]))
        return self;
    
    code    = [[errorData objectForKey:@"code"] intValue];
    message = [errorData objectForKey:@"message"];
    data    = [errorData objectForKey:@"data"];

    DS_RETAIN(message)
    DS_RETAIN(data)
    
    return self;
}

+ (DSJSONRPCError *)errorWithData:(NSDictionary *)errorData {
    DSJSONRPCError *error = [[self alloc] initWithErrorData:errorData];
    DS_AUTORELEASE(error)
    
    return error;
}

+ (instancetype)networkError:(NSError *)error {
    DSJSONRPCError *rpcError = [self new];
    rpcError->code =  -900000;
    rpcError->message = error.domain;
    
    return rpcError;
}
+ (instancetype)parseJsonError:(NSError *)error {
    DSJSONRPCError *rpcError = [self new];
    rpcError->code =  -32700;
    rpcError->message = error.domain;
    
    return rpcError;
}


- (void)dealloc {
    DS_RELEASE(message)
    DS_RELEASE(data)
    
    DS_SUPERDEALLOC()
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DSJSONRPC Error: %@ (Code: %zd) - Data: %@", self.message, self.code, self.data];
}

@end
