package org.diploma.personalaccess.web.user;

import org.apache.log4j.Logger;
import org.diploma.personalaccess.entity.Index;
import org.diploma.personalaccess.entity.Position;
import org.diploma.personalaccess.service.IndexService;
import org.diploma.personalaccess.service.PositionService;
import org.diploma.personalaccess.util.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.diploma.personalaccess.web.WebConstants.Dir;
import static org.diploma.personalaccess.web.WebConstants.Page;

/**
 * That secured area only fo admins
 *
 * @author Maksim Patapenka
 */
@PreAuthorize("hasRole('ROLE_ADMIN')")
@Controller
@RequestMapping("/admin")
public class AdminController {

    /**
     * Logger Log4j
     */
    private static final Logger log = Logger.getLogger(AdminController.class);


    @Autowired
    private IndexService indexService;

    @Autowired
    private PositionService positionService;


    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String getDashboardPage(Model model, @RequestParam(required = false) Long posId) {
        List<Index> indexes;
        if (posId != null) {
            Position position = positionService.getById(posId);
            indexes = indexService.getByPosition(position);
        } else {
            indexes = indexService.getAll();
        }
        model.addAttribute("indexes", indexes);
        model.addAttribute("positions", positionService.getAll());
        model.addAttribute("selectedPosId", posId);
        return Dir.USER + Page.ADMIN;
    }

    @ResponseBody
    @RequestMapping(value = "/dashboard/save", method = RequestMethod.POST)
    public String saveIndex(@RequestBody String data) {
        try {
            Index index = JsonParser.convertJsonStringToObject(data, Index.class);
            indexService.save(index);
            log.debug("Index '" + index.getName() + "' was saved.");
            /* Empty string it's valid format of answer */
            return "";
        } catch (RuntimeException e) {
            log.error("Error while saving index '" + data + "'.", e);
            return e.getMessage();
        }
    }

    @ResponseBody
    @RequestMapping(value = "/dashboard/get", method = RequestMethod.GET, produces = "text/plain; charset=utf-8")
    public String getIndex(@RequestParam long id) {
        Index index = indexService.getById(id);
        return JsonParser.convertObjectToJsonString(index);
    }

    @ResponseBody
    @RequestMapping(value = "/dashboard/delete", method = RequestMethod.POST)
    public String deleteIndex(long id) {
        indexService.remove(id);
        return "Index with id='" + id + "' was deleted.";
    }

}
