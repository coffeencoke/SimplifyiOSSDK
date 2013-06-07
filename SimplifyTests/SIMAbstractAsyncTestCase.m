/*
 * Copyright (c) 2013, MasterCard International Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 * conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of the MasterCard International Incorporated nor the names of its
 * contributors may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#import "SIMAbstractAsyncTestCase.h"

@implementation SIMAbstractAsyncTestCase

- (BOOL)shouldRunOnMainThread {
    return NO;
}

- (void)setUp {
    [super setUp];
    self.notifications = [NSMutableArray array];
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSUInteger)notificationCount {
    return self.notifications.count;
}

- (void)registerForEvent:(NSString *)name object:(id)object {
    GHAssertNotEquals(self, object, @"Cannot register for event on test object");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCallback:) name:name object:object];
}

- (void)waitForNotification:(NSString*)notificationName timeout:(NSTimeInterval)timeout {
    [self waitForStatus:notificationName.hash timeout:timeout];
}

- (void)notificationCallback:(NSNotification*)notification {
    [self.notifications addObject:notification];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        [self notify:notification.name.hash];
    });
}

@end