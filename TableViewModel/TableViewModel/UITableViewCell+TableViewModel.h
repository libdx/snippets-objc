//
//  UITableViewCell+TableViewModel.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (TableViewModel)

- (void)updateWithObject:(id)object;
- (void)updateObject:(id)object;

@end
