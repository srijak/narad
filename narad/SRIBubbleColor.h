//
//  SRIBubbleColor.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRIBubbleColor : NSObject

@property (nonatomic, strong) UIColor *gradientTop;
@property (nonatomic, strong) UIColor *gradientBottom;
@property (nonatomic, strong) UIColor *border;

- (id)initWithGradientTop:(UIColor *)gradientTop
           gradientBottom:(UIColor *)gradientBottom
                   border:(UIColor *)border;
@end
