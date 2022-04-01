import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template baseboard}
/// Wing-shaped board piece to corral the [Ball] towards the [Flipper]s.
/// {@endtemplate}
class Baseboard extends BodyComponent with InitialPosition {
  /// {@macro baseboard}
  Baseboard({
    required BoardSide side,
  }) : _side = side;

  /// Whether the [Baseboard] is on the left or right side of the board.
  final BoardSide _side;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];
    final direction = _side.direction;
    final arcsAngle = -1.11 * direction;
    const arcsRotation = math.pi / 2.08;

    final pegBumperShape = CircleShape()..radius = 0.7;
    pegBumperShape.position.setValues(11.11 * direction, 7.15);
    final pegBumperFixtureDef = FixtureDef(pegBumperShape);
    fixturesDef.add(pegBumperFixtureDef);

    final topCircleShape = CircleShape()..radius = 0.7;
    topCircleShape.position.setValues(9.71 * direction, 4.95);
    final topCircleFixtureDef = FixtureDef(topCircleShape);
    fixturesDef.add(topCircleFixtureDef);

    final innerEdgeShape = EdgeShape()
      ..set(
        Vector2(9.01 * direction, 5.35),
        Vector2(5.29 * direction, -0.95),
      );
    final innerEdgeShapeFixtureDef = FixtureDef(innerEdgeShape);
    fixturesDef.add(innerEdgeShapeFixtureDef);

    final outerEdgeShape = EdgeShape()
      ..set(
        Vector2(10.41 * direction, 4.75),
        Vector2(3.79 * direction, -5.95),
      );
    final outerEdgeShapeFixtureDef = FixtureDef(outerEdgeShape);
    fixturesDef.add(outerEdgeShapeFixtureDef);

    final upperArcShape = ArcShape(
      center: Vector2(0.09 * direction, 2.15),
      arcRadius: 6.1,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final upperArcFixtureDef = FixtureDef(upperArcShape);
    fixturesDef.add(upperArcFixtureDef);

    final lowerArcShape = ArcShape(
      center: Vector2(0.09 * direction, -3.35),
      arcRadius: 4.5,
      angle: arcsAngle,
      rotation: arcsRotation,
    );
    final lowerArcFixtureDef = FixtureDef(lowerArcShape);
    fixturesDef.add(lowerArcFixtureDef);

    final bottomRectangle = PolygonShape()
      ..setAsBox(
        6.8,
        2,
        Vector2(-6.3 * direction, -5.85),
        0,
      );
    final bottomRectangleFixtureDef = FixtureDef(bottomRectangle);
    fixturesDef.add(bottomRectangleFixtureDef);

    return fixturesDef;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      (_side.isLeft)
          ? Assets.images.baseboard.left.keyName
          : Assets.images.baseboard.right.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: Vector2(27.5, 17.9),
        anchor: Anchor.center,
        position: Vector2(_side.isLeft ? 0.4 : -0.4, 0),
      ),
    );

    renderBody = false;
  }

  @override
  Body createBody() {
    const angle = 37.1 * (math.pi / 180);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..angle = _side.isLeft ? -angle : angle;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}