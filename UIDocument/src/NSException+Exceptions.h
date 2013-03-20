//
//  NSException+Exceptions.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 3/2/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (Exceptions)

@end


inline static NSException *InvalidArgumentException(NSString *reason) {
    return [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

inline static NSException *InternalInconsistencyException(NSString *reason) {
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}