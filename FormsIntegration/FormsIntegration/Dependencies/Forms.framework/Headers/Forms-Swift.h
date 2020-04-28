// Generated by Apple Swift version 5.2 (swiftlang-1103.0.32.1 clang-1103.0.32.29)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreGraphics;
@import Foundation;
@import ObjectiveC;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="Forms",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class NSCoder;
@class UITraitCollection;

SWIFT_CLASS("_TtC5Forms13FormComponent")
@interface FormComponent : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection;
@end

@class UIColor;

SWIFT_CLASS("_TtC5Forms17ActivityIndicator")
@interface ActivityIndicator : FormComponent
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ActivityIndicator (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms7BarItem")
@interface BarItem : UIBarButtonItem
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms6Button")
@interface Button : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end




@interface Button (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withBackgroundColor:(UIColor * _Nullable)backgroundColor SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms20CollectionDataSource")
@interface CollectionDataSource : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIScrollView;

@interface CollectionDataSource (SWIFT_EXTENSION(Forms))
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end





@class UICollectionView;
@class UICollectionViewCell;

@interface CollectionDataSource (SWIFT_EXTENSION(Forms)) <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)collectionView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end

@class UICollectionViewLayoutAttributes;

SWIFT_CLASS("_TtC5Forms20CollectionFlowLayout")
@interface CollectionFlowLayout : UICollectionViewFlowLayout
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly) CGSize collectionViewContentSize;
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds SWIFT_WARN_UNUSED_RESULT;
- (void)prepareLayout;
- (void)invalidateLayout;
- (NSArray<UICollectionViewLayoutAttributes *> * _Nullable)layoutAttributesForElementsInRect:(CGRect)rect SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC5Forms18CollectionViewCell")
@interface CollectionViewCell : UICollectionViewCell
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end



@class NSBundle;

SWIFT_CLASS("_TtC5Forms14ViewController")
@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)viewDidLoad;
@end


SWIFT_CLASS("_TtC5Forms24CollectionViewController")
@interface CollectionViewController : ViewController <UICollectionViewDataSource, UICollectionViewDelegate>
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end








@interface CollectionViewController (SWIFT_EXTENSION(Forms))
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end


@interface CollectionViewController (SWIFT_EXTENSION(Forms))
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end










SWIFT_CLASS("_TtC5Forms7Divider")
@interface Divider : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface Divider (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end





SWIFT_CLASS("_TtC5Forms5Label")
@interface Label : FormComponent
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end




@interface Label (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)withIsUserInteractionEnabled:(BOOL)isUserInteractionEnabled SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms15LoaderCoverView")
@interface LoaderCoverView : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms10LoaderView")
@interface LoaderView : FormComponent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC5Forms14ModalCoverView")
@interface ModalCoverView : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms9ModalView")
@interface ModalView : FormComponent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC5Forms13NavigationBar")
@interface NavigationBar : FormComponent
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
@property (nonatomic, strong) UIColor * _Nullable tintColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface NavigationBar (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withBackgroundColor:(UIColor * _Nullable)backgroundColor SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms15PagerController")
@interface PagerController : ViewController
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


@interface PagerController (SWIFT_EXTENSION(Forms)) <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end





@class UICollectionViewLayout;

@interface PagerController (SWIFT_EXTENSION(Forms)) <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)collectionView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView willDisplayCell:(UICollectionViewCell * _Nonnull)cell forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didEndDisplayingCell:(UICollectionViewCell * _Nonnull)cell forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms13PrimaryButton")
@interface PrimaryButton : Button
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms15ScrollContainer")
@interface ScrollContainer : FormComponent
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ScrollContainer (SWIFT_EXTENSION(Forms)) <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView * _Nonnull)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView * _Nonnull)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end


@interface ScrollContainer (SWIFT_EXTENSION(Forms)) <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)collectionView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView willDisplayCell:(UICollectionViewCell * _Nonnull)cell forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didEndDisplayingCell:(UICollectionViewCell * _Nonnull)cell forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGSize)collectionView:(UICollectionView * _Nonnull)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end


@interface ScrollContainer (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms9SearchBar")
@interface SearchBar : FormComponent
@property (nonatomic, readonly) CGSize intrinsicContentSize;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end








@interface SearchBar (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withBackgroundColor:(UIColor * _Nullable)backgroundColor SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms13SeparatorView")
@interface SeparatorView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms27ShimmerCollectionDataSource")
@interface ShimmerCollectionDataSource : CollectionDataSource
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end




SWIFT_CLASS("_TtC5Forms25ShimmerCollectionViewCell")
@interface ShimmerCollectionViewCell : CollectionViewCell
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms15TableDataSource")
@interface TableDataSource : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class UITableViewCell;

SWIFT_CLASS("_TtC5Forms22ShimmerTableDataSource")
@interface ShimmerTableDataSource : TableDataSource
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end




SWIFT_CLASS("_TtC5Forms13TableViewCell")
@interface TableViewCell : UITableViewCell
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms20ShimmerTableViewCell")
@interface ShimmerTableViewCell : TableViewCell
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms14StackContainer")
@interface StackContainer : FormComponent
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface StackContainer (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC5Forms6TabBar")
@interface TabBar : UITabBar
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms16TabBarController")
@interface TabBarController : ViewController
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end





@interface TableDataSource (SWIFT_EXTENSION(Forms))
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end






@interface TableDataSource (SWIFT_EXTENSION(Forms)) <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end





SWIFT_CLASS("_TtC5Forms19TableViewController")
@interface TableViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end






@interface TableViewController (SWIFT_EXTENSION(Forms))
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end






@interface TableViewController (SWIFT_EXTENSION(Forms))
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
@end












SWIFT_CLASS("_TtC5Forms9TextField")
@interface TextField : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end








@interface TextField (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withBackgroundColor:(UIColor * _Nullable)backgroundColor SWIFT_WARN_UNUSED_RESULT;
@end

@class UITextField;

SWIFT_CLASS("_TtC5Forms17TextFieldDelegate")
@interface TextFieldDelegate : NSObject <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms23TextFieldAmountDelegate")
@interface TextFieldAmountDelegate : TextFieldDelegate
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (void)textFieldDidBeginEditing:(UITextField * _Nonnull)textField;
- (void)textFieldDidEndEditing:(UITextField * _Nonnull)textField;
@end



SWIFT_CLASS("_TtC5Forms22TextFieldEmailDelegate")
@interface TextFieldEmailDelegate : TextFieldDelegate
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms22TextFieldPeselDelegate")
@interface TextFieldPeselDelegate : TextFieldDelegate
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms22TextFieldPhoneDelegate")
@interface TextFieldPhoneDelegate : TextFieldDelegate
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms14TitleTextField")
@interface TitleTextField : TextField
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms9ToastView")
@interface ToastView : FormComponent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFrame:(CGRect)frame SWIFT_UNAVAILABLE;
@end




SWIFT_CLASS("_TtC5Forms6TopBar")
@interface TopBar : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface TopBar (SWIFT_EXTENSION(Forms)) <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView * _Nonnull)collectionView SWIFT_WARN_UNUSED_RESULT;
- (NSInteger)collectionView:(UICollectionView * _Nonnull)collectionView numberOfItemsInSection:(NSInteger)section SWIFT_WARN_UNUSED_RESULT;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UICollectionViewCell * _Nonnull)collectionView:(UICollectionView * _Nonnull)collectionView cellForItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath SWIFT_WARN_UNUSED_RESULT;
- (void)collectionView:(UICollectionView * _Nonnull)collectionView willDisplayCell:(UICollectionViewCell * _Nonnull)cell forItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView * _Nonnull)scrollView;
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
@end


SWIFT_CLASS("_TtC5Forms25UITextFieldWithoutPadding")
@interface UITextFieldWithoutPadding : UITextField
- (CGRect)textRectForBounds:(CGRect)bounds SWIFT_WARN_UNUSED_RESULT;
- (CGRect)placeholderRectForBounds:(CGRect)bounds SWIFT_WARN_UNUSED_RESULT;
- (CGRect)editingRectForBounds:(CGRect)bounds SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIView (SWIFT_EXTENSION(Forms))
- (void)startShimmeringWithAnimated:(BOOL)animated;
- (void)stopShimmeringWithAnimated:(BOOL)animated;
@end




SWIFT_CLASS("_TtC5Forms19UnShimmerableButton")
@interface UnShimmerableButton : UIButton
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImage;

SWIFT_CLASS("_TtC5Forms22UnShimmerableImageView")
@interface UnShimmerableImageView : UIImageView
- (nonnull instancetype)initWithImage:(UIImage * _Nullable)image OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithImage:(UIImage * _Nullable)image highlightedImage:(UIImage * _Nullable)highlightedImage OBJC_DESIGNATED_INITIALIZER SWIFT_AVAILABILITY(ios,introduced=3.0);
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms18UnShimmerableLabel")
@interface UnShimmerableLabel : UILabel
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC5Forms4View")
@interface View : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface View (SWIFT_EXTENSION(Forms))
- (nonnull instancetype)withHeight:(CGFloat)height SWIFT_WARN_UNUSED_RESULT;
@end




@class UIGestureRecognizer;

@interface ViewController (SWIFT_EXTENSION(Forms))
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer * _Nonnull)gestureRecognizer SWIFT_WARN_UNUSED_RESULT;
@end


@interface ViewController (SWIFT_EXTENSION(Forms))
- (void)keyboarWillShowForResizingWithNotification:(NSNotification * _Nonnull)notification;
- (void)keyboarWillHideForResizingWithNotification:(NSNotification * _Nonnull)notification;
@end


SWIFT_CLASS("_TtC5Forms12XibComponent")
@interface XibComponent : FormComponent
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop