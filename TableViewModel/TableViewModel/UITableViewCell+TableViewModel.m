//
//  UITableViewCell+TableViewModel.m
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import "UITableViewCell+TableViewModel.h"

@implementation UITableViewCell (TableViewModel)

- (void)updateWithObject:(id)object
{
    self.textLabel.text = self.reuseIdentifier;
}

- (void)updateObject:(id)object
{
}

@end
