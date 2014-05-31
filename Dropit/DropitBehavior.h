//
//  DropitBehavior.h
//  Dropit
//
//  Created by will hunting on 5/29/14.
//  Copyright (c) 2014 will hunting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior
-(void)addItem:(id <UIDynamicItem>)item;
-(void)removeItem:(id <UIDynamicItem>)item;
@end
