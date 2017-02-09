/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI14_0_0RNSVGBrush.h"

@interface ABI14_0_0RNSVGBaseBrush : ABI14_0_0RNSVGBrush

- (instancetype)initWithArray:(NSArray *)array;

- (void)paint:(CGContextRef)context opacity:(CGFloat)opacity brushConverter:(ABI14_0_0RNSVGBrushConverter *)brushConverter;

@end
