//
//  TDMAppDelegate.m
//  TDMSwitchTableViewCell Example
//
//  Created by Tobias DM on 12/02/14.
//  Copyright (c) 2014 developmunk. All rights reserved.
//

#import "TDMAppDelegate.h"




@interface View : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftScreenEdgeGestureRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightScreenEdgeGestureRecognizer;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior* pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehaviour;

@end


@implementation View


- (id)init
{
	self = [super init];
	if (self) {
		
		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
		_contentView.backgroundColor = [UIColor cyanColor];
		
		[self addSubview:_contentView];
		
		
		self.leftScreenEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
		self.leftScreenEdgeGestureRecognizer.edges = UIRectEdgeLeft;
		[self addGestureRecognizer:self.leftScreenEdgeGestureRecognizer];
		
		self.rightScreenEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePan:)];
		self.rightScreenEdgeGestureRecognizer.edges = UIRectEdgeRight;
		[self addGestureRecognizer:self.rightScreenEdgeGestureRecognizer];
		
		
		[self setupContentViewControllerAnimatorProperties];
		
	}
	return self;
	
}
- (void)setupContentViewControllerAnimatorProperties
{
    NSAssert(self.animator == nil, @"Animator is not nil – setupContentViewControllerAnimatorProperties likely called twice.");
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.contentView]];
    // Need to create a boundary that lies to the left off of the right edge of the screen.
    [collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, -280)];
    [self.animator addBehavior:collisionBehaviour];
    
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.contentView]];
    self.gravityBehaviour.gravityDirection = CGVectorMake(-1, 0);
    [self.animator addBehavior:self.gravityBehaviour];
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.contentView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.0f;
    self.pushBehavior.angle = 0.0f;
    [self.animator addBehavior:self.pushBehavior];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentView]];
    itemBehaviour.elasticity = 0.45f;
    [self.animator addBehavior:itemBehaviour];
}

#pragma mark - Gesture Recognizer Methods

-(void)handleScreenEdgePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    location.y = CGRectGetMidY(self.contentView.bounds);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.gravityBehaviour];
        
        self.panAttachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.contentView attachedToAnchor:location];
        [self.animator addBehavior:self.panAttachmentBehaviour];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.panAttachmentBehaviour.anchorPoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.panAttachmentBehaviour], self.panAttachmentBehaviour = nil;
        
        CGPoint velocity = [gestureRecognizer velocityInView:self];
        
        if (velocity.x > 0) {
            
            self.gravityBehaviour.gravityDirection = CGVectorMake(1, 0);
        }
        else {
            
            self.gravityBehaviour.gravityDirection = CGVectorMake(-1, 0);
        }
        
        [self.animator addBehavior:self.gravityBehaviour];
        
        self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10.0f, 0);
        self.pushBehavior.active = YES;
    }
}

@end






#import "TDMSwitchTableViewCell.h"

@interface ViewController : UITableViewController <TDMSwitchTableViewCellDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

#define cellIdentifier @"cellIdentifier"

@implementation ViewController

- (void)viewDidLoad
{
	// Setup view
	self.title = @"TDMSwitchTableViewCell";
	
	{
		self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		
		[self.tableView registerClass:[TDMSwitchTableViewCell class] forCellReuseIdentifier:cellIdentifier];
		self.tableView.separatorInset = UIEdgeInsetsZero;
	}
	
	{
//		self.view.backgroundColor = [UIColor lightGrayColor];
//		
//		
//		
//		View *view = [View new];
//		view.frame = self.view.bounds;
//		[self.view addSubview:view];
//		
//		CGRect frame = CGRectMake(0, 200, 320, 44);
//		TDMSwitchTableViewCell *cell = [TDMSwitchTableViewCell new];
//		cell.textLabel.text = @"Test";
//		cell.backgroundColor = [UIColor whiteColor];
//		[self.view addSubview:cell];
//		cell.frame = frame;
	}
	
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TDMSwitchTableViewCell *cell = (TDMSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	[self configureCell:cell];
	return cell;
}

- (void)configureCell:(TDMSwitchTableViewCell *)cell
{
	cell.textLabel.text = cell.on ? @"This cell is on" : @"This cell is off";
	cell.delegate = self;
}


#pragma mark - TDMSwitchTableViewCellDelegate

- (void)switchTableViewCell:(TDMSwitchTableViewCell *)cell didChangeState:(BOOL)stateOn
{
	[self configureCell:cell];
}


@end






@implementation TDMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
