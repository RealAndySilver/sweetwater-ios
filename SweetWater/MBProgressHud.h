//
//  MBProgressHud.h
//
//  Created by Andrés Abril on 22/10/12.
//
//



#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    MBProgressHUDModeIndeterminate,
	MBProgressHUDModeDeterminate,
	MBProgressHUDModeCustomView
} MBProgressHUDMode;

typedef enum {
    MBProgressHUDAnimationFade,
    MBProgressHUDAnimationZoom
} MBProgressHUDAnimation;

@protocol MBProgressHUDDelegate <NSObject>

@required


- (void)hudWasHidden;

@end


@interface MBRoundProgressView : UIProgressView {}


- (id)initWithDefaultSize;

@end


@interface MBProgressHUD : UIView {
	
	MBProgressHUDMode mode;
    MBProgressHUDAnimation animationType;
	
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	BOOL useAnimation;
	
    float yOffset;
    float xOffset;
	
	float width;
	float height;
	
	float margin;
	
	BOOL taskInProgress;
	float graceTime;
	float minShowTime;
	NSTimer *graceTimer;
	NSTimer *minShowTimer;
	NSDate *showStarted;
	
	UIView *indicator;
	UILabel *label;
	UILabel *detailsLabel;
	
	float progress;
	
	id<MBProgressHUDDelegate> delegate;
	NSString *labelText;
	NSString *detailsLabelText;
	float opacity;
	UIFont *labelFont;
	UIFont *detailsLabelFont;
	
    BOOL isFinished;
	BOOL removeFromSuperViewOnHide;
	
	UIView *customView;
	
	CGAffineTransform rotationTransform;
}


+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;


+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;


- (id)initWithWindow:(UIWindow *)window;


- (id)initWithView:(UIView *)view;


@property (retain) UIView *customView;


@property (assign) MBProgressHUDMode mode;


@property (assign) MBProgressHUDAnimation animationType;


@property (assign) id<MBProgressHUDDelegate> delegate;


@property (copy) NSString *labelText;


@property (copy) NSString *detailsLabelText;


@property (assign) float opacity;


@property (assign) float xOffset;


@property (assign) float yOffset;


@property (assign) float margin;


@property (assign) float graceTime;


@property (assign) float minShowTime;


@property (assign) BOOL taskInProgress;


@property (assign) BOOL removeFromSuperViewOnHide;


@property (retain) UIFont* labelFont;


@property (retain) UIFont* detailsLabelFont;


@property (assign) float progress;


- (void)show:(BOOL)animated;


- (void)hide:(BOOL)animated;

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

@end
