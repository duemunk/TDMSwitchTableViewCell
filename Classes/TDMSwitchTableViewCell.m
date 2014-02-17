//
//  TDMSwitchTableViewCell.m
//  TDMSwitchTableViewCell Example
//
//  Created by Tobias DM on 12/02/14.
//  Copyright (c) 2014 developmunk. All rights reserved.
//

#import "TDMSwitchTableViewCell.h"


@interface TDMSwitchTableViewCell () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) UIView *switchView;
@property (strong, nonatomic) NSLayoutConstraint *switchViewWidthConstraint;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehaviour;
@property (strong, nonatomic) UICollisionBehavior *collisionBehaviour;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachmentBehaviour;
@property (strong, nonatomic) UIPushBehavior *pushBehaviour;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehaviour;
@property (assign, nonatomic) BOOL temporaryToggleOn;

@end

@implementation TDMSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		// Default values
		_on = YES;
		_onTintColor = [UIColor colorWithRed:0.27f green:0.85f blue:0.46f alpha:1.0f];
		_offTintColor = [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f];
		_activeWidth = 5;
		_activationWidth = 60;

		// SwitchView
		self.backgroundView = [UIView new];

		_switchView = [UIView new];
		[self.backgroundView addSubview:_switchView];
		
		UIView *contentView = self.contentView;
		NSDictionary *views = NSDictionaryOfVariableBindings(_switchView,contentView);
		_switchView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchView]|" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_switchView]" options:0 metrics:nil views:views]];
		self.switchViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_switchView
																	  attribute:NSLayoutAttributeWidth
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:nil
																	  attribute:NSLayoutAttributeNotAnAttribute
																	 multiplier:0.0
																	   constant:_activeWidth];
		[self addConstraint:self.switchViewWidthConstraint];
	
		[self updateSwitchViewColor];
		
		// Gesture
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		[self addGestureRecognizer:pan];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
		[self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	[self.switchView bringSubviewToFront:self];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!_animator) {
		// Dynamics
		self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
		
		self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.contentView]];
		[self.collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -CGRectGetWidth(self.frame))];
		//		CGPoint topLeft = self.contentView.frame.origin;
		//		CGPoint bottomLeft = topLeft;
		//		bottomLeft.y = CGRectGetMaxY(self.contentView.frame);
		//		topLeft.x =
		//		bottomLeft.x = -0.5;
		//		[self.collisionBehaviour addBoundaryWithIdentifier:@"leftEdge" fromPoint:topLeft toPoint:bottomLeft];
		//		self.collisionBehaviour.collisionDelegate = self;
		[self.animator addBehavior:self.collisionBehaviour];
		
		self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.contentView]];
		self.gravityBehaviour.gravityDirection = CGVectorMake(-6.0f, 0.0f);
		self.gravityBehaviour.action = ^{
			[self updateSwitchViewWidth];
		};
		[self.animator addBehavior:self.gravityBehaviour];
		
		self.pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[self.contentView] mode:UIPushBehaviorModeInstantaneous];
		[self.animator addBehavior:self.pushBehaviour];
		
		self.itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
		self.itemBehaviour.elasticity = 0.45f;
		self.itemBehaviour.allowsRotation = NO;
		[self.animator addBehavior:self.itemBehaviour];
	}
}


- (void)setOn:(BOOL)on
{
	if (on != _on) {
		_on = on;
	
		if ([self.delegate respondsToSelector:@selector(switchTableViewCell:didChangeState:)]) {
			[self.delegate switchTableViewCell:self didChangeState:self.on];
		}
	}
	
	[self updateSwitchViewColor];
}
- (void)setTemporaryToggleOn:(BOOL)temporaryToggleOn
{
	if (temporaryToggleOn != _temporaryToggleOn) {
		_temporaryToggleOn = temporaryToggleOn;
		
		[self updateSwitchViewColor];
	}
}



- (void)setOnTintColor:(UIColor *)onTintColor
{
	if (onTintColor != _onTintColor) {
		_onTintColor = onTintColor;
		[self updateSwitchViewColor];
	}
}
- (void)setOffTintColor:(UIColor *)offTintColor
{
	if (offTintColor != _offTintColor) {
		_offTintColor = offTintColor;
		[self updateSwitchViewColor];
	}
}


- (void)updateSwitchViewColor
{
	BOOL on = self.on;
	if (self.temporaryToggleOn) {
		on = !on;
	}
	
	self.switchView.backgroundColor = on ? self.onTintColor : self.offTintColor;
	[self.switchView bringSubviewToFront:self];
}
- (void)updateSwitchViewWidth
{
	CGFloat width = self.activeWidth + CGRectGetMinX(self.contentView.frame);
	width = MAX(width, 0);
	self.switchViewWidthConstraint.constant = width;
}





- (void)setActiveWidth:(CGFloat)activeWidth
{
	if (activeWidth != _activeWidth) {
		_activeWidth = activeWidth;
		
		[self updateSwitchViewWidth];
	}
}


- (BOOL)isCrossActivationWidth
{
	return (self.switchView.frame.size.width >= self.activationWidth);
}





- (void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateEnded)
	{
		CGPoint point = [gesture locationInView:gesture.view];
		if (point.x < 44.0f)
		{
			self.pushBehaviour.pushDirection = CGVectorMake(10.0f, 0.0f);
			self.pushBehaviour.active = YES;
		}
	}
}




- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
	CGPoint location = [gesture locationInView:self];
	location.y = CGRectGetMidY(self.contentView.bounds);
	
	CGPoint translation = [gesture translationInView:self];
	
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
		[self.animator removeAllBehaviors];
		
//        self.panAttachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.contentView attachedToAnchor:location];
//
//		self.panAttachmentBehaviour.action = ^{
//			self.temporaryToggleOn = [self isCrossActivationWidth];
//			
//			[self updateSwitchViewWidth];
//		};

//		[self.animator addBehavior:self.panAttachmentBehaviour];
    }
    
	if (gesture.state == UIGestureRecognizerStateBegan ||
		gesture.state == UIGestureRecognizerStateChanged)
    {
//        self.panAttachmentBehaviour.anchorPoint = location;
		
		CGRect frame = self.contentView.frame;
		frame.origin.x += translation.x;
		if (frame.origin.x > 0) {
			self.contentView.frame = frame;
		}
		[gesture setTranslation:CGPointZero inView:self];
		
		[self updateSwitchViewWidth];
		self.temporaryToggleOn = [self isCrossActivationWidth];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
//		[self.animator removeBehavior:self.panAttachmentBehaviour];
//		self.panAttachmentBehaviour = nil;
		
		[self.animator addBehavior:self.gravityBehaviour];
		[self.animator addBehavior:self.pushBehaviour];
		[self.animator addBehavior:self.itemBehaviour];
		[self.animator addBehavior:self.collisionBehaviour];
		
		CGPoint velocity = [gesture velocityInView:self.contentView];
		velocity.y = 0;
        [self.itemBehaviour addLinearVelocity:velocity forItem:self.contentView];
		
		self.temporaryToggleOn = NO;
		if ([self isCrossActivationWidth]) {
			self.on = !self.on;
		}
    }
}

@end
