//
//  UIDocument+ConvenienceMethods.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 10/24/12.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDocument (ConvenienceMethods)

// IO operations are performed in background

- (void)saveCreating;
- (void)saveOverwriting;

- (void)saveCreatingWithCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)saveOverwritingWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
