from .material_station_geometry import Scene as BaseScene

class Scene(BaseScene):

    def node(self, *args, **kwargs):
        yaw = kwargs.pop('r', 0.0)
        fresh = args[0] not in self.nodes
        key = super().node(*args, **kwargs)
        if fresh:
            self.nodes[key]['r'] = yaw
        if self.dynamic:
            self.poses[key]['r'] = yaw
            self.poses[key]['rx'] = kwargs.get('rx', 0.0)
            self.poses[key]['rz'] = kwargs.get('rz', 0.0)
        return key
