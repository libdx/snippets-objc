//
//  NSManagedObject+TableViewModel.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/20/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TableViewModelObjects.h"

@interface NSManagedObject (TableViewModel)

@end


@interface TableViewModel (TableViewModel)
- (void)eachRow:(void (^)(TableViewRow *row))callback;
@end
