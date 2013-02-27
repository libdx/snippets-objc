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
- (id)objectThroughContext:(NSManagedObject *)object;
+ (NSManagedObjectContext *)threadContext;
- (NSManagedObjectContext *)newChildContext;
- (void)recursiveSave;
@end

#define ManagedObjectContextSave(ctx) NSError *e; if (![ctx save:&e]) log_error(e);
#define ManagedObjectContextRecursiveSave(ctx) NSError *e; if (![ctx recursiveSave:&e]) log_error(e);
