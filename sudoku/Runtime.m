//
//  Runtime.m
//  sudoku
//
//  Created by slee on 2015/12/28.
//  Copyright © 2015年 slee. All rights reserved.
//

#import "Runtime.h"

@implementation Runtime




+ (BOOL)isDebug {
    
#ifdef DEBUG
    return true;
#else
    return false;
#endif
}

+ (BOOL)isProd {
    return ![self isDebug];
}


@end
