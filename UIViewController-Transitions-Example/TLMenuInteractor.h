//
//  TLMenuInteractor.h
//  UIViewController-Transitions-Example
//
//  Created by Ash Furrow on 2013-07-18.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMenuInteractor : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

-(id)initWithParentViewController:(UIViewController *)viewController;

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, readonly) UIViewController *parentViewController;

-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer;
-(void)presentMenu;

@end