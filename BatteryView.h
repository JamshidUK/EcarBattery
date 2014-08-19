//
//  BatteryView.h
//  EcarMap
//
//  Created by Jamshid Ummattam Kuzhiyil on 20/03/14.
//  Copyright (c) 2014 Hochschule (Fakultaet Elektrotechnik und Informatik). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatteryView : UIView {
@private
    NSUInteger minimum;
    NSUInteger maximum;
    NSUInteger minBgWidth;
    NSUInteger maxBgWidth;
    NSUInteger currentValue_;
    UIImageView* foregroundLayer;
    UIImageView* backgroundLayer;
    UIImage* imageCache[3];
    BOOL animate;
}

// the minimum value of this gage
@property (nonatomic, assign) NSUInteger minimum;
// the maximum value of this gage
@property (nonatomic, assign) NSUInteger maximum;
// the current value (will be between minimum and maximum)
@property (nonatomic, assign) NSUInteger currentValue;
// should the view animate when currentValue is changed?
@property (nonatomic, assign) BOOL animate;

@end
