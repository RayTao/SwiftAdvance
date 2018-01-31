//
//  CBridging.m
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/31.
//  Copyright © 2018年 ray. All rights reserved.
//

#import "CBridging.h"

@implementation CBridging

+ (int)my_scanf:(NSString *)input {
    const char *text = [input cStringUsingEncoding:NSUTF8StringEncoding];
    int result = scanf("%s",text);
    return result;
}

+ (void)my_printf:(NSString *)output {
    printf([output cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
