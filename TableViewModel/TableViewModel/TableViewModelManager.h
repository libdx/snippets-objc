
//
//  TableViewModelManager.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewModelManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (TableViewModelManager *)sharedManager;

@end
