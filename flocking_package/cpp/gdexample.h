#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/multi_mesh_instance2d.hpp>
#include <godot_cpp/classes/rendering_device.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/classes/sprite2d.hpp>

namespace godot {

    class FlockDotCpp : public RefCounted {
        GDCLASS(FlockDotCpp, RefCounted)

    public:
        Vector2 current_position;
        Vector2 target_position;
        Vector2 velocity;
        Color color;

    protected:
        static void _bind_methods();

    public:
        FlockDotCpp();
        ~FlockDotCpp();

        void set_current_position(Vector2 _current_position);
        Vector2 get_current_position() const;

        void set_target_position(Vector2 _target_position);
        Vector2 get_target_position() const;

        void set_velocity(Vector2 _velocity);
        Vector2 get_velocity() const;

        void set_color(Color _color);
        Color get_color() const;
    };

    class FlockCpp : public RefCounted {
        GDCLASS(FlockCpp, RefCounted)

    public:
        Sprite2D* owner;
        Vector2 size;
        int base_index = 0;

    protected:
        static void _bind_methods();

    public:
        FlockCpp();
        ~FlockCpp();

        TypedArray<FlockDotCpp> dots;

        void set_owner(Sprite2D* _owner);
        Sprite2D* get_owner() const;

        void set_size(Vector2 _size);
        Vector2 get_size() const;

        int get_dots_count();
        void add_dot(FlockDotCpp* _dot);
    };

    class GDExample : public MultiMeshInstance2D {
        GDCLASS(GDExample, MultiMeshInstance2D)

    public:
        RenderingDevice* rd;

        PackedFloat32Array dots_array;
        PackedFloat32Array flocks_array;

        PackedByteArray dots_bytes;
        PackedByteArray flocks_bytes;
        PackedByteArray params_bytes;

        PackedByteArray dots_output_buffer;

        RID dots_buffer;
        RID flocks_buffer;
        RID params_buffer;

        RID noise_rid;

        RID uniform_set;
        RID pipeline;

        Ref<Texture2D> noise_texture;

        bool is_submitted = false;

        TypedArray<FlockCpp> flocks;

        void update_flock_buffers();
        void update_flock_array();
        void update_buffers(double delta);

        void compute();
        void sync();

        void retrieve_output();
        void update_mesh();

    protected:
        static void _bind_methods();

    public:
        GDExample();
        ~GDExample();

        void _ready() override;
        void _process(double delta) override;

        void set_noise_texture(Ref<Texture2D> p_noise_texture);
        Ref<Texture2D> get_noise_texture() const;

        void add_flock(FlockCpp* flock);
        void remove_flock(Ref<FlockCpp> flock);
    };
}

#endif