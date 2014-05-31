//
//  DropitViewController.m
//  Dropit
//
//  Created by will hunting on 5/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DropitViewController.h"
#import "DropitBehavior.h"
#import "DropitView.h"

@interface DropitViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet DropitView *gameView;
@property (nonatomic, strong)UIDynamicAnimator* animator;
@property (strong, nonatomic)DropitBehavior* dropitBehavior;
@property (nonatomic, strong)UIAttachmentBehavior* attachment;
@property (nonatomic, strong)UIView* droppingView;
@end

@implementation DropitViewController

const static CGSize DROP_SIZE = {40, 40};

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (DropitBehavior *)dropitBehavior
{
    if (!_dropitBehavior) {
        _dropitBehavior = [[DropitBehavior alloc]init];
        [self.animator addBehavior:_dropitBehavior];
    }
    return _dropitBehavior;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

- (BOOL)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width-DROP_SIZE.width/2; x += DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
        return YES;
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView *drop in dropsToRemove) {
            int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, -y);
        }
    }
                     completion:^(BOOL finished) {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

- (void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = arc4random()%(int)(self.gameView.bounds.size.width/DROP_SIZE.width);
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView* dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    [self.dropitBehavior addItem:dropView];
    
    self.droppingView = dropView;
}

- (UIColor*)randomColor
{
    switch (arc4random()%5) {
        case 1: return [UIColor greenColor];
        case 2: return [UIColor blueColor];
        case 3: return [UIColor orangeColor];
        case 4: return [UIColor redColor];
        case 5: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint ancherPoint = [sender locationInView:self.gameView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewtoPoint:ancherPoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = ancherPoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

- (void)attachDroppingViewtoPoint:(CGPoint)anchor
{
    if (self.droppingView) {
        __weak DropitViewController* weakSelf = self;
        UIView* droppingView = self.droppingView;
        self.attachment = [[UIAttachmentBehavior alloc]initWithItem:self.droppingView attachedToAnchor:anchor];
        self.attachment.action = ^{
            UIBezierPath* path = [[UIBezierPath alloc]init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

@end
