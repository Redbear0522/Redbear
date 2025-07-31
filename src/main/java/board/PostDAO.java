package board;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class PostDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static PostDAO instance = new PostDAO();
    public static PostDAO getInstance() {
        return instance;
    }
    private PostDAO() {}

    // PostgreSQL 연결 메서드
    private Connection connect() {
        try {
            Class.forName("org.postgresql.Driver");
            String url  ="postgresql://redbearstorage_02d4_user:6cgrFSNQY4fcoNmX2Zm7kheOPqEZKnvq@dpg-d24nbuali9vc73eftdkg-a.singapore-postgres.render.com/redbearstorage_02d4";
	        String user = "redbearstorage_02d4_user";
	        String pass = "6cgrFSNQY4fcoNmX2Zm7kheOPqEZKnvq";
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 리소스 해제
    private void disconnect() {
        try { if (rs    != null) rs.close();    } catch (SQLException ignored) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
        try { if (conn  != null) conn.close();  } catch (SQLException ignored) {}
    }

    /** 1. 글 등록 */
    public int insertPost(PostDTO pd) {
        int result = 0;
        int num      = pd.getNum();
        int ref      = pd.getRef();
        int re_step  = pd.getRe_step();
        int re_level = pd.getRe_level();
        int number   = 0;

        try {
            conn = connect();
            // 최대 num 조회
            String maxSql = "SELECT COALESCE(MAX(num),0) FROM public.post";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            if (rs.next()) number = rs.getInt(1) + 1;
            rs.close(); pstmt.close();

            // 답글 처리
            if (num != 0) {
                String uSql = "UPDATE public.post SET re_step = re_step + 1 WHERE ref = ? AND re_step > ?";
                pstmt = conn.prepareStatement(uSql);
                pstmt.setInt(1, ref);
                pstmt.setInt(2, re_step);
                pstmt.executeUpdate();
                pstmt.close();
                re_step++; re_level++;
            } else {
                ref = number; re_step = 0; re_level = 0;
            }

            // INSERT: regdate, readcnt는 테이블 기본값 사용, 컬럼에서 제거
            String iSql =
                "INSERT INTO public.post(" +
                " num,writer,title,content,pw,ip,ref,re_step,re_level" +
                ") VALUES (" +
                " nextval('post_sq'), ?,?,?,?,?,?,?,?" +
                ")";
            pstmt = conn.prepareStatement(iSql);
            pstmt.setString(1, pd.getWriter());
            pstmt.setString(2, pd.getTitle());
            pstmt.setString(3, pd.getContent());
            pstmt.setString(4, pd.getPw());
            pstmt.setString(5, pd.getIp());
            pstmt.setInt   (6, ref);
            pstmt.setInt   (7, re_step);
            pstmt.setInt   (8, re_level);

            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** 2. 글 목록 (페이징) */
    public List<PostDTO> getPostList(int start, int end) {
        List<PostDTO> list = new ArrayList<>();
        int limit  = end - start + 1;
        int offset = start - 1;
        String sql =
            "SELECT num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt " +
            "FROM public.post " +
            "ORDER BY ref DESC,re_step ASC " +
            "LIMIT ? OFFSET ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setPw(rs.getString("pw"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
                dto.setRe_level(rs.getInt("re_level"));
                dto.setContent(rs.getString("content"));
                dto.setIp(rs.getString("ip"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 3. 글 보기 */
    public PostDTO getPost(int num) {
        PostDTO dto = null;
        String sql = "SELECT * FROM public.post WHERE num = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new PostDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 4. 조회수 증가 */
    public void setReadCountUpdate(int num) {
        String sql = "UPDATE public.post SET readcnt = COALESCE(readcnt, 0) + 1 WHERE num = ?";
        try {
            conn = connect();
            if (conn == null) {
                System.out.println("데이터베이스 연결 실패");
                return;
            }
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            int result = pstmt.executeUpdate();
            System.out.println("조회수 업데이트 결과: " + result + " 행이 수정됨");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    /** 5. 글 수정 */
    public int updatePost(PostDTO dto) {
        int res = 0;
        String sql = "UPDATE public.post SET title = ?, content = ? WHERE num = ? AND pw = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.getNum());
            pstmt.setString(4, dto.getPw());
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    /** 6. 글 삭제 */
    public int deletePost(int num, String pw) {
        int res = 0;
        String sql = "DELETE FROM public.post WHERE num = ? AND pw = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, pw);
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    /** 7. 전체 글 개수 */
    public int getArticleCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM public.post";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }
}
