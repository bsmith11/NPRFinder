//
//  ProgramsViewController.m
//  NPRFinder
//
//  Created by Bradley Smith on 1/20/15.
//  Copyright (c) 2015 Bradley Smith. All rights reserved.
//

#import "ProgramsViewController.h"
#import "UITableView+NPRFinder.h"
#import "ProgramTableViewCell.h"
#import "UITableViewCell+NPRFinder.h"
#import "Program.h"
#import "UIButton+NPRFinder.h"
#import "UILabel+NPRFinder.h"
#import "UIView+NPRFinder.h"

static NSString * const kTitleLabelText = @"Programs";

static const CGFloat kSlideAnimationDuration = 0.7;
static const CGFloat kSlideAnimationDelay = 0.0;
static const CGFloat kSlideAnimationSpringDamping = 0.8;
static const CGFloat kSlideAnimationSpringVelocity = 1.0;

static const UIViewAnimationOptions kDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState;

@interface ProgramsViewController ()

@property (copy, nonatomic) NSArray *programs;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonTop;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *programTableView;

@end

@implementation ProgramsViewController

#pragma mark - View Lifecycle

- (instancetype)initWithPrograms:(NSArray *)programs {
    self = [super init];
    
    if (self) {
        _programs = programs;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setupBackButton];
    [self setupTitleLabel];
    [self setupProgramTableView];
    
    [self hideBackButtonAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self showBackButtonAnimated:YES completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.backButton npr_setAlpha:0.0 duration:kSlideAnimationDuration animated:YES completion:nil];
    } completion:nil];
}

#pragma mark - Setup

- (void)setupBackButton {
    [self.backButton npr_setupWithStyle:NPRButtonStyleBackButton
                                 target:self
                                 action:@selector(backButtonPressed)];
}

- (void)setupTitleLabel {
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleTitle];
    [self.titleLabel setText:kTitleLabelText];
}

- (void)setupProgramTableView {
    [self.programTableView npr_setupWithStyle:NPRTableViewStyleProgram
                                     delegate:self
                                   dataSource:self];
    
    [self.programTableView setAlwaysBounceVertical:NO];
}

#pragma mark - Actions

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.programs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProgramTableViewCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ProgramTableViewCell npr_reuseIdentifier] forIndexPath:indexPath];
    
    Program *program = self.programs[indexPath.row];
    
    [cell setupWithProgram:program];
    
    return cell;
}

#pragma mark - Animations

- (void)hideBackButtonAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self animateBackButtonToPosition:-(self.backButtonHeight.constant + self.navigationBarContainerTop.constant) animated:animated completion:completion];
}

- (void)showBackButtonAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    [self animateBackButtonToPosition:0 animated:animated completion:completion];
}

- (void)animateBackButtonToPosition:(CGFloat)position animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    if (animated) {
        [UIView animateWithDuration:kSlideAnimationDuration
                              delay:kSlideAnimationDelay
             usingSpringWithDamping:kSlideAnimationSpringDamping
              initialSpringVelocity:kSlideAnimationSpringVelocity
                            options:kDefaultAnimationOptions
                         animations:^{
                             [self.backButtonTop setConstant:position];
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:completion];
    }
    else {
        [self.backButtonTop setConstant:position];
        
        if (completion) {
            completion(YES);
        }
    }
}

@end
