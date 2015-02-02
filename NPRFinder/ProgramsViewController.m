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

@interface ProgramsViewController ()

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *titleLabel;

@property (copy, nonatomic) NSArray *programs;

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
    
    [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationSlideVertically
                                            animated:NO
                                          completion:nil];
    [self.nprNavigationBar hideMiddleItemWithAnimation:NPRItemAnimationSlideVertically
                                              animated:NO
                                            completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [self.transitionCoordinator animateAlongsideTransitionInView:window animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.nprNavigationBar showLeftItemWithAnimation:NPRItemAnimationSlideVertically
                                                animated:YES
                                              completion:nil];
        [self.nprNavigationBar showRightItemWithAnimation:NPRItemAnimationSlideVertically
                                                 animated:YES
                                               completion:nil];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [self.transitionCoordinator animateAlongsideTransitionInView:window animation:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.nprNavigationBar hideLeftItemWithAnimation:NPRItemAnimationSlideVertically
                                                animated:YES
                                              completion:nil];
        [self.nprNavigationBar hideRightItemWithAnimation:NPRItemAnimationSlideVertically
                                                 animated:YES
                                               completion:nil];
    } completion:nil];
}

#pragma mark - Setup

- (void)setupBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton npr_setupWithStyle:NPRButtonStyleBackButton
                                 target:self
                                 action:@selector(backButtonPressed)];
    [self.nprNavigationBar setLeftItem:self.backButton];
}

- (void)setupTitleLabel {
    self.titleLabel = [UILabel new];
    [self.titleLabel npr_setupWithStyle:NPRLabelStyleTitle];
    [self.titleLabel setText:kTitleLabelText];
    [self.titleLabel sizeToFit];
    [self.nprNavigationBar setMiddleItem:self.titleLabel];
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

@end
