//
//  NSString+Convenience.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 3/2/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convenience)

@end

#define STRFormat(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]

