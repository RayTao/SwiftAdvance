//
//  CBridging.h
//  SwiftAdvanceUnitTest
//
//  Created by ray on 2018/1/31.
//  Copyright © 2018年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBridging : NSObject
+ (int)my_scanf:(NSString *)input;
+ (void)my_printf:(NSString *)output;
@end
