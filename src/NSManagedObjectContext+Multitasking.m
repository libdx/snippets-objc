//
//  NSManagedObjectContext+Multitasking.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 2/27/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <objc/runtime.h>
#import "NSManagedObjectContext+Multitasking.h"

@implementation NSManagedObjectContext (Multitasking)

- (id)objectThroughContext:(NSManagedObject *)object
{
    return [self objectWithID:object.objectID];
}

+ (NSManagedObjectContext *)threadContext
{
    NSThread *thread = [NSThread currentThread];
    static const char *const ThreadContextKey = "threadContext";
    NSManagedObjectContext *ctx = objc_getAssociatedObject(thread, ThreadContextKey);
    if (ctx == nil) {
        if (thread.isMainThread) {
            ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            // setup persistend store etc...
        } else {
            ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            ctx.parentContext = nil; // TODO: assign main thread context
        }
        objc_setAssociatedObject(thread, ThreadContextKey, ctx, OBJC_ASSOCIATION_RETAIN);
    }
    return ctx;
}

- (NSManagedObjectContext *)newChildContext
{
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc]
                                   initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    ctx.parentContext = self;
    return ctx;
}

- (void)recursiveSave
{
    [self performBlock:^{
        NSError *error;
        if (![self save:&error])
            log_error(error);
        if (self.parentContext) {
            [self.parentContext recursiveSave];
        }
    }];
}
@end
