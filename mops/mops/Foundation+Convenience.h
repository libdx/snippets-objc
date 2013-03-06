//
//  NSObject+Convenience.h
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Convenience)

@end

@interface NSException (Convenience)
- (NSException *)internalInconsistencyExceptionWithReason:(NSString *)reason;
@end

inline static NSException *InternalInconsistencyException(NSString *reason) {
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}
