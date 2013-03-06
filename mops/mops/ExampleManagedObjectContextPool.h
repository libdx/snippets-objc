//
//  ExampleManagedPool.h
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import "ManagedObjectContextPool.h"

@interface ExampleManagedObjectContextPool : ManagedObjectContextPool

+ (ExampleManagedObjectContextPool *)sharedPool;

@end
