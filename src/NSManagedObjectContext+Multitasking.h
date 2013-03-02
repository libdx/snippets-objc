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
+ (instancetype)threadContext; // ??
- (NSManagedObjectContext *)newChildContext;
- (NSManagedObjectContext *)newBackgroundChildContext;
- (id)objectThroughContext:(NSManagedObject *)object;
- (void)recursiveSaveTrackingErrors:(void (^)(NSError *error))tracker;
@end
