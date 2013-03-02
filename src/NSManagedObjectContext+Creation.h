//
//  NSManagedObjectContext+Creation.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 3/2/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Creation)
+ (instancetype)rootManagedObjectContext;
@end
