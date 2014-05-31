//
//  DropitBehavior.m
//  Dropit
//
//  Created by will hunting on 5/29/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()
@property (strong, nonatomic)UIGravityBehavior* gravity;
@property (strong, nonatomic)UICollisionBehavior* collider;
@property (strong, nonatomic)UIDynamicItemBehavior* animationOption;
@end

@implementation DropitBehavior

-(UIDynamicItemBehavior *)animationOption
{
    if (!_animationOption) {
        _animationOption = [[UIDynamicItemBehavior alloc]init];
        _animationOption.allowsRotation = NO;
    }
    return _animationOption;
}

-(UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
    }
    return _gravity;
}

-(UICollisionBehavior *)collider
{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}

-(void)addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
    [self.animationOption addItem:item];
}

-(void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOption removeItem:item];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collider];
        [self addChildBehavior:self.animationOption];
    }
    return self;
}
@end
