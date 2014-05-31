//
//  CustomScrollView.m
//  TheSign
//
//  Created by Andrey Chudnovskiy on 2014-05-31.
//  Copyright (c) 2014 Andrey Chudnovskiy. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self superview]touchesEnded:touches withEvent:event];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
