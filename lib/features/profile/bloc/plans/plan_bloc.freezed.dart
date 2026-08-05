// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlanEvent {

 String get name;
/// Create a copy of PlanEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanEventCopyWith<PlanEvent> get copyWith => _$PlanEventCopyWithImpl<PlanEvent>(this as PlanEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanEvent&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'PlanEvent(name: $name)';
}


}

/// @nodoc
abstract mixin class $PlanEventCopyWith<$Res>  {
  factory $PlanEventCopyWith(PlanEvent value, $Res Function(PlanEvent) _then) = _$PlanEventCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$PlanEventCopyWithImpl<$Res>
    implements $PlanEventCopyWith<$Res> {
  _$PlanEventCopyWithImpl(this._self, this._then);

  final PlanEvent _self;
  final $Res Function(PlanEvent) _then;

/// Create a copy of PlanEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanEvent].
extension PlanEventPatterns on PlanEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllPlans value)?  allPlans,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllPlans() when allPlans != null:
return allPlans(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllPlans value)  allPlans,}){
final _that = this;
switch (_that) {
case _AllPlans():
return allPlans(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllPlans value)?  allPlans,}){
final _that = this;
switch (_that) {
case _AllPlans() when allPlans != null:
return allPlans(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name)?  allPlans,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllPlans() when allPlans != null:
return allPlans(_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name)  allPlans,}) {final _that = this;
switch (_that) {
case _AllPlans():
return allPlans(_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name)?  allPlans,}) {final _that = this;
switch (_that) {
case _AllPlans() when allPlans != null:
return allPlans(_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _AllPlans implements PlanEvent {
  const _AllPlans({required this.name});
  

@override final  String name;

/// Create a copy of PlanEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllPlansCopyWith<_AllPlans> get copyWith => __$AllPlansCopyWithImpl<_AllPlans>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllPlans&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'PlanEvent.allPlans(name: $name)';
}


}

/// @nodoc
abstract mixin class _$AllPlansCopyWith<$Res> implements $PlanEventCopyWith<$Res> {
  factory _$AllPlansCopyWith(_AllPlans value, $Res Function(_AllPlans) _then) = __$AllPlansCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$AllPlansCopyWithImpl<$Res>
    implements _$AllPlansCopyWith<$Res> {
  __$AllPlansCopyWithImpl(this._self, this._then);

  final _AllPlans _self;
  final $Res Function(_AllPlans) _then;

/// Create a copy of PlanEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_AllPlans(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PlanState {

 Status get allPlanStatus; SubscriptionPlansResponse? get allPlans;
/// Create a copy of PlanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanStateCopyWith<PlanState> get copyWith => _$PlanStateCopyWithImpl<PlanState>(this as PlanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanState&&(identical(other.allPlanStatus, allPlanStatus) || other.allPlanStatus == allPlanStatus)&&(identical(other.allPlans, allPlans) || other.allPlans == allPlans));
}


@override
int get hashCode => Object.hash(runtimeType,allPlanStatus,allPlans);

@override
String toString() {
  return 'PlanState(allPlanStatus: $allPlanStatus, allPlans: $allPlans)';
}


}

/// @nodoc
abstract mixin class $PlanStateCopyWith<$Res>  {
  factory $PlanStateCopyWith(PlanState value, $Res Function(PlanState) _then) = _$PlanStateCopyWithImpl;
@useResult
$Res call({
 Status allPlanStatus, SubscriptionPlansResponse? allPlans
});




}
/// @nodoc
class _$PlanStateCopyWithImpl<$Res>
    implements $PlanStateCopyWith<$Res> {
  _$PlanStateCopyWithImpl(this._self, this._then);

  final PlanState _self;
  final $Res Function(PlanState) _then;

/// Create a copy of PlanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allPlanStatus = null,Object? allPlans = freezed,}) {
  return _then(_self.copyWith(
allPlanStatus: null == allPlanStatus ? _self.allPlanStatus : allPlanStatus // ignore: cast_nullable_to_non_nullable
as Status,allPlans: freezed == allPlans ? _self.allPlans : allPlans // ignore: cast_nullable_to_non_nullable
as SubscriptionPlansResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanState].
extension PlanStatePatterns on PlanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanState value)  $default,){
final _that = this;
switch (_that) {
case _PlanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanState value)?  $default,){
final _that = this;
switch (_that) {
case _PlanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status allPlanStatus,  SubscriptionPlansResponse? allPlans)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanState() when $default != null:
return $default(_that.allPlanStatus,_that.allPlans);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status allPlanStatus,  SubscriptionPlansResponse? allPlans)  $default,) {final _that = this;
switch (_that) {
case _PlanState():
return $default(_that.allPlanStatus,_that.allPlans);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status allPlanStatus,  SubscriptionPlansResponse? allPlans)?  $default,) {final _that = this;
switch (_that) {
case _PlanState() when $default != null:
return $default(_that.allPlanStatus,_that.allPlans);case _:
  return null;

}
}

}

/// @nodoc


class _PlanState implements PlanState {
  const _PlanState({this.allPlanStatus = Status.init, this.allPlans = null});
  

@override@JsonKey() final  Status allPlanStatus;
@override@JsonKey() final  SubscriptionPlansResponse? allPlans;

/// Create a copy of PlanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanStateCopyWith<_PlanState> get copyWith => __$PlanStateCopyWithImpl<_PlanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanState&&(identical(other.allPlanStatus, allPlanStatus) || other.allPlanStatus == allPlanStatus)&&(identical(other.allPlans, allPlans) || other.allPlans == allPlans));
}


@override
int get hashCode => Object.hash(runtimeType,allPlanStatus,allPlans);

@override
String toString() {
  return 'PlanState(allPlanStatus: $allPlanStatus, allPlans: $allPlans)';
}


}

/// @nodoc
abstract mixin class _$PlanStateCopyWith<$Res> implements $PlanStateCopyWith<$Res> {
  factory _$PlanStateCopyWith(_PlanState value, $Res Function(_PlanState) _then) = __$PlanStateCopyWithImpl;
@override @useResult
$Res call({
 Status allPlanStatus, SubscriptionPlansResponse? allPlans
});




}
/// @nodoc
class __$PlanStateCopyWithImpl<$Res>
    implements _$PlanStateCopyWith<$Res> {
  __$PlanStateCopyWithImpl(this._self, this._then);

  final _PlanState _self;
  final $Res Function(_PlanState) _then;

/// Create a copy of PlanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allPlanStatus = null,Object? allPlans = freezed,}) {
  return _then(_PlanState(
allPlanStatus: null == allPlanStatus ? _self.allPlanStatus : allPlanStatus // ignore: cast_nullable_to_non_nullable
as Status,allPlans: freezed == allPlans ? _self.allPlans : allPlans // ignore: cast_nullable_to_non_nullable
as SubscriptionPlansResponse?,
  ));
}


}

// dart format on
