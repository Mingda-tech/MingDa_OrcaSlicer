#include "GLGizmoAD.hpp"
#include "slic3r/GUI/GLCanvas3D.hpp"
#include "slic3r/GUI/GUI_App.hpp"
//BBS: GUI refactor
#include "slic3r/GUI/Plater.hpp"
#include "libslic3r/AppConfig.hpp"

#include <wx/process.h>
#include <wx/wx.h>
#include <wx/txtstrm.h>

#include <GL/glew.h>

#include <wx/utils.h>
#include <wx/protocol/http.h>
#include <wx/timer.h>

namespace Slic3r {
namespace GUI {



//BBS: GUI refactor: add obj manipulation
GLGizmoAD::GLGizmoAD(GLCanvas3D& parent, const std::string& icon_filename, unsigned int sprite_id, GizmoObjectManipulation* obj_manipulation)
    : GLGizmoBase(parent, icon_filename, sprite_id)
    //BBS: GUI refactor: add obj manipulation
    , m_object_manipulation(obj_manipulation)
{
    //set_state(EState::On);
  /*  m_process = new wxProcess();
    m_timer   = new wxTimer();*/
    //Connect(wxEVT_TIMER, wxTimerEventHandler(GLGizmoAD::OnTimer));
    //m_timer->Connect(wxEVT_TIMER, wxTimerEventHandler(GLGizmoAD::OnTimer));
    //m_timer->Start(100); // 设置定时器间隔为 100 毫秒
}

std::string GLGizmoAD::get_tooltip() const
{
    const Selection& selection = m_parent.get_selection();
    bool show_position = selection.is_single_full_instance();
    const Vec3d& position = selection.get_bounding_box().center();


    return "";
}

bool GLGizmoAD::on_mouse(const wxMouseEvent &mouse_event) {
    //return use_grabbers(mouse_event);
    BOOST_LOG_TRIVIAL(warning) << __FUNCTION__ << boost::format("GLGizmoAD::on_mouse!");
    return false;
}

void GLGizmoAD::data_changed(bool is_serializing) {
    //m_grabbers[2].enabled = !m_parent.get_selection().is_wipe_tower();
    printf("GLGizmoAD::data_changed\n");
    BOOST_LOG_TRIVIAL(warning) << __FUNCTION__ << boost::format("GLGizmoAD::data_changed!");
    // 获取当前执行程序的绝对路径
    wxString exePath = wxStandardPaths::Get().GetExecutablePath();
    auto     config  = wxStandardPaths::Get().GetLocalDataDir();
    auto     config1  = wxStandardPaths::Get().GetPluginsDir();
    auto     config12 = wxStandardPaths::Get().GetConfigDir();
    auto     config21  = wxStandardPaths::Get().GetDataDir();
    // 如果只需要路径部分，可以使用 wxFileName::ExtractPath 方法
    wxString exeDir = wxFileName(exePath).GetPath();
    // 获取当前工作目录
    wxString currentDir = wxGetCwd();
    // 输出程序路径
    wxLogMessage("The executable path is: %s", exePath);
    // wxProcess使用，异步读取另一个程序的标准输出 
    //auto process = new wxProcess();
    //process->Redirect();
    exeDir += "/AdWordCraft/AdWordCraft.exe";
    auto execute = wxExecute(exeDir, wxEXEC_ASYNC);

     // 启动外部程序
    if (execute != 0) {
        // 读取来自进程的输出
        //wxInputStream* stream = process->GetInputStream();
        //if (stream){
        //    wxTextInputStream* textStream = new wxTextInputStream(*stream,wxT("\n"));
        //    wxString           line;
        //    while (!textStream->Eof()) {
        //        line = textStream->ReadLine();
        //        wxMessageBox(line); // 显示每一行
        //    }
        //    delete textStream;
        //
        //}

    }
}

bool GLGizmoAD::on_init()
{
    //for (int i = 0; i < 3; ++i) {
    //    m_grabbers.push_back(Grabber());
    //    m_grabbers.back().extensions = GLGizmoBase::EGrabberExtension::PosZ;
    //}

    //m_grabbers[0].angles = { 0.0, 0.5 * double(PI), 0.0 };
    //m_grabbers[1].angles = { -0.5 * double(PI), 0.0, 0.0 };

    m_shortcut_key = WXK_CONTROL_M;
    //set_state(EState::On);
    return true;
}

std::string GLGizmoAD::on_get_name() const
{
    return _u8L("AD");
}

bool GLGizmoAD::on_is_activable() const
{
    //TODO:ylg ad Ĭ�ϵĲ˵�����������Ҫѡ��ģ��
   // return !m_parent.get_selection().is_empty();
    return true;
}

void GLGizmoAD::on_start_dragging()
{
    assert(m_hover_id != -1);


    const BoundingBoxf3& box = m_parent.get_selection().get_bounding_box();

}

void GLGizmoAD::on_stop_dragging()
{
   // m_parent.do_move(L("Gizmo-Move"));
    
}

void GLGizmoAD::on_dragging(const UpdateData& data)
{
    
}

void GLGizmoAD::on_render()
{
    //const Selection& selection = m_parent.get_selection();

    //glsafe(::glClear(GL_DEPTH_BUFFER_BIT));
    //glsafe(::glEnable(GL_DEPTH_TEST));

    //const BoundingBoxf3& box = selection.get_bounding_box();
    //const Vec3d& center = box.center();
    //float space_size = 20.f *INV_ZOOM;

}

void GLGizmoAD::on_register_raycasters_for_picking()
{
    // the gizmo grabbers are rendered on top of the scene, so the raytraced picker should take it into account
   // m_parent.set_raycaster_gizmos_on_top(true);
}

void GLGizmoAD::on_unregister_raycasters_for_picking()
{
   // m_parent.set_raycaster_gizmos_on_top(false);
}

//BBS: add input window for move
void GLGizmoAD::on_render_input_window(float x, float y, float bottom_limit)
{
    //if (m_object_manipulation)
    //    m_object_manipulation->do_render_move_window(m_imgui, "AD", x, y, bottom_limit);
    BOOST_LOG_TRIVIAL(warning) << __FUNCTION__ << boost::format("GLGizmoAD::on_render_input_window!");
        
}


double GLGizmoAD::calc_projection(const UpdateData& data) const
{
    double projection = 0.0;



    return projection;
}
void GLGizmoAD::OnExecute(wxCommandEvent& event) {
    
}
void GLGizmoAD::OnTimer(wxTimerEvent& event) {}
void GLGizmoAD::ReadProcessOutput() {
    //wxInputStream* stream = m_process->GetInputStream();
    //if (stream && stream->CanRead()) {
    //    wxString output = stream->ReadAll();
    //   
    //}

    //wxInputStream* errorStream = m_process->GetErrorStream();
    //if (errorStream && errorStream->CanRead()) {
    //    wxString errors = errorStream->ReadAll();
    //    
    //}

    //if (!m_process->IsRunning()) {
    //    m_timer->Stop();
    //    m_process->Detach();
    //    delete m_process;
    //    m_process = NULL;
    //}

}
} // namespace GUI
} // namespace Slic3r
