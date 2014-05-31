//
//  DropitView.m
//  Dropit
//
//  Created by will hunting on 5/30/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "DropitView.h"

@implementation DropitView

-(void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [self.path stroke];
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
