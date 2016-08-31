//
//  TLMasterViewController.m
//  UIViewController-Transitions-Example
//
//  Created by Ash Furrow on 2013-07-12.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLMasterViewController.h"
#import "TLMenuViewController.h"

#import "TLDetailViewController.h"

#import "TLTransitionAnimator.h"
#import "TLMenuInteractor.h"
#import "TLMenuDynamicInteractor.h"




#define USE_UIKIT_DYNAMICS      NO





@interface TLMasterViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) id<TLMenuViewControllerPanTarget> menuInteractor;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizerPan ;

@end

@implementation TLMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (USE_UIKIT_DYNAMICS) {
        self.menuInteractor = [[TLMenuDynamicInteractor alloc] initWithParentViewController:self];
    }
    else {
        self.menuInteractor = [[TLMenuInteractor alloc] initWithParentViewController:self];
    }
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.menuInteractor action:@selector(presentMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.gestureRecognizerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self.menuInteractor action:@selector(userDidPan:)];
//    self.gestureRecognizerPan.edges = UIRectEdgeBottom;
    [self.view addGestureRecognizer:_gestureRecognizerPan];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *detailViewController = segue.destinationViewController;
    
    detailViewController.transitioningDelegate = self;
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = @"Present view controller";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Note: The Storyboard segue will take care of presenting the view controller
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    
    TLTransitionAnimator *animator = [TLTransitionAnimator new];
    //Configure the animator
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TLTransitionAnimator *animator = [TLTransitionAnimator new];
    return animator;
}

#pragma mark - 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:self.gestureRecognizerPan] && [otherGestureRecognizer isEqual:self.tableView.panGestureRecognizer]){
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.gestureRecognizerPan]) {
        if (gestureRecognizer.numberOfTouches > 0) {
            CGPoint translation = [self.gestureRecognizerPan velocityInView:self.tableView];
            return fabs(translation.y) > fabs(translation.x);
        } else {
            return NO;
        }
    }
    return YES;
}

@end


