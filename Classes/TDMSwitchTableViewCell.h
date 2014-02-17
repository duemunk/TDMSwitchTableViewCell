//
//  TDMSwitchTableViewCell.h
//  TDMSwitchTableViewCell Example
//
//  Created by Tobias DM on 12/02/14.
//  Copyright (c) 2014 developmunk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TDMSwitchTableViewCellDelegate;


@interface TDMSwitchTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL on;
@property (strong, nonatomic) UIColor *onTintColor, *offTintColor;
@property (assign, nonatomic) CGFloat activeWidth;
@property (assign, nonatomic) CGFloat activationWidth;
@property (weak, nonatomic) id<TDMSwitchTableViewCellDelegate> delegate;

@end


@protocol TDMSwitchTableViewCellDelegate <NSObject>

- (void)switchTableViewCell:(TDMSwitchTableViewCell *)cell didChangeState:(BOOL)stateOn;

@end
