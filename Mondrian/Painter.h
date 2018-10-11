//
//  Painter.h
//  Mondrian
//
//  Created by eggman qi on 2018/10/11.
//  Copyright © 2018 EBrainStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Painter : NSObject

+ (Painter *)mondrian;
- (void)paintingOn:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
