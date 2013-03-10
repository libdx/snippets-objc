//
//  AppDelegate.h
//  mapping
//
//  Created by Alexander Ignatenko on 3/8/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSManagedObjectContext *)context;

@end
