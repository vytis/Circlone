// Generated by Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
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
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
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
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

@interface UIColor (SWIFT_EXTENSION(DynamicColor))

/// Creates a color from an hex string.
///
/// \param hexString A hexa-decimal color string representation.
- (nonnull instancetype)initWithHexString:(NSString * __nonnull)hexString;

/// Creates a color from an hex integer.
///
/// \param hex A hexa-decimal UInt32 that represents a color.
- (nonnull instancetype)initWithHex:(uint32_t)hex;

/// Returns the color representation as hexadecimal string.
///
/// \returns  A string similar to this pattern "#f4003b".
- (NSString * __nonnull)toHexString;

/// Returns the color representation as an integer.
///
/// \returns  A UInt32 that represents the hexa-decimal color.
- (uint32_t)toHex;

/// The red component as CGFloat between 0.0 to 1.0.
@property (nonatomic, readonly) CGFloat redComponent;

/// The green component as CGFloat between 0.0 to 1.0.
@property (nonatomic, readonly) CGFloat greenComponent;

/// The blue component as CGFloat between 0.0 to 1.0.
@property (nonatomic, readonly) CGFloat blueComponent;

/// The alpha component as CGFloat between 0.0 to 1.0.
@property (nonatomic, readonly) CGFloat alphaComponent;

/// Creates and returns a color object with the alpha increased by the given amount.
///
/// \param amount CGFloat between 0.0 and 1.0.
///
/// \returns  A color object with its alpha channel modified.
- (UIColor * __nonnull)adjustedAlphaColor:(CGFloat)amount;

/// Initializes and returns a color object using the specified opacity and HSL component values.
///
/// \param hue The hue component of the color object, specified as a value from 0.0 to 1.0 (0.0 for 0 degree and 1.0 for 360 degree).
///
/// \param saturation The saturation component of the color object, specified as a value from 0.0 to 1.0.
///
/// \param lightness The lightness component of the color object, specified as a value from 0.0 to 1.0.
///
/// \param alpha The opacity value of the color object, specified as a value from 0.0 to 1.0.
- (nonnull instancetype)initWithHue:(double)hue saturation:(double)saturation lightness:(double)lightness alpha:(double)alpha;

/// Returns a boolean value that indicates whether the receiver is equal to the given hexa-decimal string.
///
/// \param hexString A hexa-decimal color number representation to be compared to the receiver.
///
/// \returns  true if the receiver and the string are equals, otherwise false.
- (BOOL)isEqualToHexString:(NSString * __nonnull)hexString;

/// Returns a boolean value that indicates whether the receiver is equal to the given hexa-decimal integer.
///
/// \param hex A UInt32 that represents the hexa-decimal color.
///
/// \returns  true if the receiver and the integer are equals, otherwise false.
- (BOOL)isEqualToHex:(uint32_t)hex;

/// Creates and returns a color object with the hue rotated along the color wheel by the given amount.
///
/// \param amount A double representing the number of degrees as ratio (usually -1.0 for -360 degree and 1.0 for 360 degree).
///
/// \returns  A DynamicColor object with the hue changed.
- (UIColor * __nonnull)adjustedHueColor:(double)amount;

/// Creates and returns the complement of the color object.
///
/// This is identical to adjustedHueColor(0.5).\See 
///
/// adjustedHueColor:
///
/// \returns  The complement DynamicColor.
- (UIColor * __nonnull)complementColor;

/// Creates and returns a lighter color object.\See 
///
/// lightenColor:
///
/// \returns  An DynamicColor lightened with an amount of 0.2.
- (UIColor * __nonnull)lighterColor;

/// Creates and returns a color object with the lightness increased by the given amount.
///
/// \param amount Double between 0.0 and 1.0.
///
/// \returns  A lighter DynamicColor.
- (UIColor * __nonnull)lightenColor:(double)amount;

/// Creates and returns a darker color object.\See 
///
/// darkenColor:
///
/// \returns  A DynamicColor darkened with an amount of 0.2.
- (UIColor * __nonnull)darkerColor;

/// Creates and returns a color object with the lightness decreased by the given amount.
///
/// \param amount Float between 0.0 and 1.0.
///
/// \returns  A darker DynamicColor.
- (UIColor * __nonnull)darkenColor:(double)amount;

/// Creates and returns a color object with the saturation increased by the given amount.\See 
///
/// saturateColor:
///
/// \returns  A DynamicColor more saturated with an amount of 0.2.
- (UIColor * __nonnull)saturatedColor;

/// Creates and returns a color object with the saturation increased by the given amount.
///
/// \param amount Double between 0.0 and 1.0.
///
/// \returns  A DynamicColor more saturated.
- (UIColor * __nonnull)saturateColor:(double)amount;

/// Creates and returns a color object with the saturation decreased by the given amount.\See 
///
/// desaturateColor:
///
/// \returns  A DynamicColor less saturated with an amount of 0.2.
- (UIColor * __nonnull)desaturatedColor;

/// Creates and returns a color object with the saturation decreased by the given amount.
///
/// \param amount Double between 0.0 and 1.0.
///
/// \returns  A DynamicColor less saturated.
- (UIColor * __nonnull)desaturateColor:(double)amount;

/// Creates and returns a color object converted to grayscale.
///
/// This is identical to desaturateColor(1).\See 
///
/// desaturateColor:
///
/// \returns  A grayscale DynamicColor.
- (UIColor * __nonnull)grayscaledColor;

/// Creates and return a color object where the red, green, and blue values are inverted, while the opacity is left alone.
///
/// \returns  An inverse (negative) of the original color.
- (UIColor * __nonnull)invertColor;

/// Determines if the color object is dark or light.
///
/// It is useful when you need to know whether you should display the text in black or white.
///
/// \returns  A boolean value to know whether the color is light. If true the color is light, dark otherwise.
- (BOOL)isLightColor;

/// Mixes the given color object with the receiver.
///
/// Specifically, takes the average of each of the RGB components, optionally weighted by the given percentage. The opacity of the colors object is also considered when weighting the components.
///
/// \param color A color object to mix with the receiver.
///
/// \param weight The weight specifies the amount of the given color object (between 0 and 1). The default value is 0.5, which means that half the given color and half the receiver color object should be used. 0.25 means that a quarter of the given color object and three quarters of the receiver color object should be used.
///
/// \returns  A color object corresponding to the two colors object mixed together.
- (UIColor * __nonnull)mixWithColor:(UIColor * __nonnull)color weight:(CGFloat)weight;

/// Creates and returns a color object corresponding to the mix of the receiver and an amount of white color, which increases lightness.
///
/// \param amount Float between 0.0 and 1.0. The default amount is equal to 0.2.
///
/// \returns  A lighter DynamicColor.
- (UIColor * __nonnull)tintColorWithAmount:(CGFloat)amount;

/// Creates and returns a color object corresponding to the mix of the receiver and an amount of black color, which reduces lightness.
///
/// \param amount Float between 0.0 and 1.0. The default amount is equal to 0.2.
///
/// \returns  A darker DynamicColor.
- (UIColor * __nonnull)shadeColorWithAmount:(CGFloat)amount;
@end

#pragma clang diagnostic pop