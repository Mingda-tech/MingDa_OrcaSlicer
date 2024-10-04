#ifndef slic3r_GLGizmoAD_hpp_
#define slic3r_GLGizmoAD_hpp_

#include "GLGizmoBase.hpp"
//BBS: add size adjust related
#include "GizmoObjectManipulation.hpp"


namespace Slic3r {
namespace GUI {

//BBS: GUI refactor: add object manipulation
class GizmoObjectManipulation;
class GLGizmoAD : public GLGizmoBase
{


    struct GrabberConnection
    {
        GLModel model;
        Vec3d old_center{ Vec3d::Zero() };
    };
    std::array<GrabberConnection, 3> m_grabber_connections;

    //BBS: add size adjust related
    GizmoObjectManipulation* m_object_manipulation;

public:
    //BBS: add obj manipulation logic
    //GLGizmoAD(GLCanvas3D& parent, const std::string& icon_filename, unsigned int sprite_id);
    GLGizmoAD(GLCanvas3D& parent, const std::string& icon_filename, unsigned int sprite_id, GizmoObjectManipulation* obj_manipulation);
    ~GLGizmoAD(){ 
        //delete m_process;
        //delete m_timer;
    };



    std::string get_tooltip() const override;

    /// <summary>
    /// Postpone to Grabber for move
    /// </summary>
    /// <param name="mouse_event">Keep information about mouse click</param>
    /// <returns>Return True when use the information otherwise False.</returns>
    bool on_mouse(const wxMouseEvent &mouse_event) override;

    /// <summary>
    /// Detect reduction of move for wipetover on selection change
    /// </summary>
    void data_changed(bool is_serializing) override;
protected:
    bool on_init() override;
    std::string on_get_name() const override;
    bool on_is_activable() const override;
    void on_start_dragging() override;
    void on_stop_dragging() override;
    void on_dragging(const UpdateData& data) override;
    void on_render() override;
    void on_register_raycasters_for_picking() override;
    void on_unregister_raycasters_for_picking() override;
    //BBS: GUI refactor: add object manipulation
    virtual void on_render_input_window(float x, float y, float bottom_limit);

private:
    double calc_projection(const UpdateData& data) const;
    void   OnExecute(wxCommandEvent& event);
    void   OnTimer(wxTimerEvent& event);
    void   ReadProcessOutput();

    //wxProcess* m_process;
    //wxTimer*   m_timer;
};



} // namespace GUI
} // namespace Slic3r

#endif // slic3r_GLGizmoAD_hpp_
