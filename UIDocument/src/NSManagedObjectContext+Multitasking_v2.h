//
//  NSManagedObjectContext+Multitasking.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 02/26/13.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Multitasking)
+ (instancetype)mainContext;
- (instancetype)newChildContext; // returns Main Concurrency context on main thread Private Concurrency type otherwise
- (instancetype)newBackgroundChildContext;
- (id)objectThroughContext:(NSManagedObject *)object;
- (void)recursiveSaveTrackingErrors:(void (^)(NSError *error))tracker;
@end
