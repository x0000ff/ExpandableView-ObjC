//
//  ExpandableVC.m
//  ExpandableView
//
//  Created by x0000ff on 17/05/16.
//  Copyright © 2016 NeuroBand. All rights reserved.
//

//##############################################################################
#import "ExpandableVC.h"

//##############################################################################
@interface ExpandableVC()

@property (weak, nonatomic) IBOutlet UIButton * collapseExpandButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * collapsedBottomConstaraint;

@end

//##############################################################################
@implementation ExpandableVC

//##############################################################################
- (void) viewDidLoad {

    [super viewDidLoad];

    // Force collapse
    UILayoutPriority newPriority = [self expandedPriority] - 1;
    self.collapsedBottomConstaraint.priority = newPriority;
    [self updateCollapseExpandButtonTitle];
}

//##############################################################################
- (UILayoutPriority) expandedPriority {
    return UILayoutPriorityDefaultHigh;
}

//##############################################################################
- (BOOL) isExpanded {
    return self.collapsedBottomConstaraint.priority <= [self expandedPriority];
}

//##############################################################################
- (IBAction) collapseExpandTapped:(id)sender {

    BOOL doExpand = [self isExpanded];
    UILayoutPriority expandedPriority = [self expandedPriority];

    UILayoutPriority newPriority = doExpand ? expandedPriority + 1 : expandedPriority - 1;
    [self applyPriority:newPriority];
}

//##############################################################################
- (void) updateCollapseExpandButtonTitle {

    NSString * newTitle = [self isExpanded] ? @"Collapse" : @"Expand";
    [self.collapseExpandButton setTitle:newTitle forState:UIControlStateNormal];
}

//##############################################################################
- (void) applyPriority:(UILayoutPriority)priority {

    [self.view layoutIfNeeded]; // force layout before animating

    self.collapsedBottomConstaraint.priority = priority;
    __weak __typeof(self)weakSelf = self;

    NSTimeInterval duration = 0.5;

    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf updateCollapseExpandButtonTitle];
    }];
}

//##############################################################################
- (IBAction) priorityTapped:(id)sender {

    UIButton * tappedButton = [sender isKindOfClass:UIButton.class] ? (UIButton *)sender : nil;

    if (!tappedButton) {
        NSLog(@"WTF? \"sender\" must be a Button. But it is: %@", sender);
        exit(1);
    }

    UILayoutPriority priority = tappedButton.currentTitle.integerValue;
    [self applyPriority:priority];
}

//##############################################################################
@end
//##############################################################################
