//
//  SRIBubbleColor.m
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIBubbleColor.h"

@implementation SRIBubbleColor
- (id)initWithGradientTop:(UIColor *)gradientTop
           gradientBottom:(UIColor *)gradientBottom
                   border:(UIColor *)border {
  if (self = [super init]) {
    self.gradientTop = gradientTop;
    self.gradientBottom = gradientBottom;
    self.border = border;
  }
  return self;
}
@end
