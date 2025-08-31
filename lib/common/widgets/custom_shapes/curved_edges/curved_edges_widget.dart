import 'package:flutter/material.dart';

import 'curved_edges.dart';

class NCurvedEdgeWidget extends StatelessWidget {
  const NCurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: NCustomCurvedEdges(),
        child: child
    );
  }
}