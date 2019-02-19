import 'dart:convert';

Waterlevel waterlevelFromJson(String str) {
    final jsonData = json.decode(str);
    return Waterlevel.fromJson(jsonData);
}

String waterlevelToJson(Waterlevel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Waterlevel {
    Level level;
    State state;

    Waterlevel({
        this.level,
        this.state,
    });

    factory Waterlevel.fromJson(Map<String, dynamic> json) => new Waterlevel(
        level: Level.fromJson(json["level"]),
        state: State.fromJson(json["state"]),
    );

    Map<String, dynamic> toJson() => {
        "level": level.toJson(),
        "state": state.toJson(),
    };
}

class Level {
    int tlevel;
    int slevel;

    Level({
        this.tlevel,
        this.slevel,
    });

    factory Level.fromJson(Map<String, dynamic> json) => new Level(
        tlevel: json["Tlevel"],
        slevel: json["Slevel"],
    );

    Map<String, dynamic> toJson() => {
        "Tlevel": tlevel,
        "Slevel": slevel,
    };
}

class State {
    int pump;

    State({
        this.pump,
    });

    factory State.fromJson(Map<String, dynamic> json) => new State(
        pump: json["pump"],
    );

    Map<String, dynamic> toJson() => {
        "pump": pump,
    };
}