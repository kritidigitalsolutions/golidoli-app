// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentEvent()';
}


}

/// @nodoc
class $ContentEventCopyWith<$Res>  {
$ContentEventCopyWith(ContentEvent _, $Res Function(ContentEvent) __);
}


/// Adds pattern-matching-related methods to [ContentEvent].
extension ContentEventPatterns on ContentEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllContent value)?  allContent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllContent() when allContent != null:
return allContent(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllContent value)  allContent,}){
final _that = this;
switch (_that) {
case _AllContent():
return allContent(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllContent value)?  allContent,}){
final _that = this;
switch (_that) {
case _AllContent() when allContent != null:
return allContent(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allContent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllContent() when allContent != null:
return allContent();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allContent,}) {final _that = this;
switch (_that) {
case _AllContent():
return allContent();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allContent,}) {final _that = this;
switch (_that) {
case _AllContent() when allContent != null:
return allContent();case _:
  return null;

}
}

}

/// @nodoc


class _AllContent implements ContentEvent {
  const _AllContent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentEvent.allContent()';
}


}




/// @nodoc
mixin _$ContentState {

 Status get allContentStatus; HomeContentResponse? get allContents;
/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentStateCopyWith<ContentState> get copyWith => _$ContentStateCopyWithImpl<ContentState>(this as ContentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentState&&(identical(other.allContentStatus, allContentStatus) || other.allContentStatus == allContentStatus)&&(identical(other.allContents, allContents) || other.allContents == allContents));
}


@override
int get hashCode => Object.hash(runtimeType,allContentStatus,allContents);

@override
String toString() {
  return 'ContentState(allContentStatus: $allContentStatus, allContents: $allContents)';
}


}

/// @nodoc
abstract mixin class $ContentStateCopyWith<$Res>  {
  factory $ContentStateCopyWith(ContentState value, $Res Function(ContentState) _then) = _$ContentStateCopyWithImpl;
@useResult
$Res call({
 Status allContentStatus, HomeContentResponse? allContents
});




}
/// @nodoc
class _$ContentStateCopyWithImpl<$Res>
    implements $ContentStateCopyWith<$Res> {
  _$ContentStateCopyWithImpl(this._self, this._then);

  final ContentState _self;
  final $Res Function(ContentState) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allContentStatus = null,Object? allContents = freezed,}) {
  return _then(_self.copyWith(
allContentStatus: null == allContentStatus ? _self.allContentStatus : allContentStatus // ignore: cast_nullable_to_non_nullable
as Status,allContents: freezed == allContents ? _self.allContents : allContents // ignore: cast_nullable_to_non_nullable
as HomeContentResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentState].
extension ContentStatePatterns on ContentState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentState value)  $default,){
final _that = this;
switch (_that) {
case _ContentState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentState value)?  $default,){
final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status allContentStatus,  HomeContentResponse? allContents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that.allContentStatus,_that.allContents);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status allContentStatus,  HomeContentResponse? allContents)  $default,) {final _that = this;
switch (_that) {
case _ContentState():
return $default(_that.allContentStatus,_that.allContents);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status allContentStatus,  HomeContentResponse? allContents)?  $default,) {final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that.allContentStatus,_that.allContents);case _:
  return null;

}
}

}

/// @nodoc


class _ContentState implements ContentState {
  const _ContentState({this.allContentStatus = Status.init, this.allContents = null});
  

@override@JsonKey() final  Status allContentStatus;
@override@JsonKey() final  HomeContentResponse? allContents;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentStateCopyWith<_ContentState> get copyWith => __$ContentStateCopyWithImpl<_ContentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentState&&(identical(other.allContentStatus, allContentStatus) || other.allContentStatus == allContentStatus)&&(identical(other.allContents, allContents) || other.allContents == allContents));
}


@override
int get hashCode => Object.hash(runtimeType,allContentStatus,allContents);

@override
String toString() {
  return 'ContentState(allContentStatus: $allContentStatus, allContents: $allContents)';
}


}

/// @nodoc
abstract mixin class _$ContentStateCopyWith<$Res> implements $ContentStateCopyWith<$Res> {
  factory _$ContentStateCopyWith(_ContentState value, $Res Function(_ContentState) _then) = __$ContentStateCopyWithImpl;
@override @useResult
$Res call({
 Status allContentStatus, HomeContentResponse? allContents
});




}
/// @nodoc
class __$ContentStateCopyWithImpl<$Res>
    implements _$ContentStateCopyWith<$Res> {
  __$ContentStateCopyWithImpl(this._self, this._then);

  final _ContentState _self;
  final $Res Function(_ContentState) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allContentStatus = null,Object? allContents = freezed,}) {
  return _then(_ContentState(
allContentStatus: null == allContentStatus ? _self.allContentStatus : allContentStatus // ignore: cast_nullable_to_non_nullable
as Status,allContents: freezed == allContents ? _self.allContents : allContents // ignore: cast_nullable_to_non_nullable
as HomeContentResponse?,
  ));
}


}

// dart format on
