//
//  TableViewModels.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewModelManager.h"

@class TableViewModel;

@interface TableViewModelManager (TableViewModels)

extern NSString *const DetailedTableViewModelID;

- (TableViewModel *)detailedTableViewModel;

@end
