;
// Set listeners to control events
$("#positions").change(loadIndexesForPosition);
$("#add-index-btn").click(saveIndex);
$("#delete-index-btn").click(deleteIndex);
$("#show-add-modal-btn").click(showAddModal);


// Load available indexes for selected position
function loadIndexesForPosition() {
    var posId = $("#positions").val();
    var url = $("#loadIndexesForm").attr("action") + "?" + $.param({posId: posId});
    location.replace(url);
}

// Create index and send it to server
function saveIndex() {
    if (!emptyValidator() || !numberBiggerThenZeroValidator()) {
        return;
    }

    var form = $("#index-form");
    var selectedPoses = $("#selected-poses").val();

    var poses = [];
    $.each(selectedPoses, function (index, value) {
        poses.push({
            id: value
        });
    });

    var index = form.serializeObject();
    // Delete index if not exist. That need for use one method for add and edit index
    !index.id && delete index.id;
    index.availablePositions = poses;

    // Setup archived flag
    delete index.isArchived;
    index.isArchived = $("#isArchived:checked").val() !== undefined;

    var jsonIndex = convertToJsonForTransfer(index);

    $.ajax({
        url: form.attr("action"),
        type: form.attr("method"),
        data: jsonIndex,
        success: function (result) {
            console.log("Save index success: " + result);
            location.reload();
        },
        error: function (error) {
            console.log("Save index error: " + error);
            Materialize.toast("Server error when u try to save the index!", 4000);
        }
    });
}

// Send index delete request
function deleteIndex() {
    var form = $("#delete-form");
    $.ajax({
        url: form.attr("action"),
        type: form.attr("method"),
        data: form.serialize(),
        success: function (result) {
            console.log("Delete index success: " + result);
            location.reload();
        },
        error: function (error) {
            console.log("Delete index error: " + error);
            Materialize.toast("Server error when u try to delete index!", 4000);
        }
    });
}


// Show and fill add index modal
function showAddModal() {
    $("#addModalHeader").html($("#addIndexHeader").html());
    $("#index-form")[0].reset();
    $("#form-id").val("");
    $("input,textarea").next("label").removeClass("active");
    $("#selected-poses").val($("#positions").val());
    $("select").material_select();
    $("#add-index").openModal();
}

// Show and fill edit index modal
function showEditModal(id) {
    $("#addModalHeader").html($("#editIndexHeader").html());
    var form = $("#getIndexForm");
    $.ajax({
        url: form.attr("action") + "?id=" + id,
        type: form.attr("method"),
        contentType: "text/plain; charset=UTF-8",
        success: function (result) {
            var obj = JSON.parse(result);
            $("#form-id").val(obj["id"]);
            $("#name").val(obj["name"]);
            $("#estimate").val(obj["estimate"]);
            $("#multiplier").val(obj["multiplier"]);
            $("#workName").val(obj["workName"]);
            $("#isArchived").prop("checked", obj["isArchived"]);

            var selected = [];
            obj.availablePositions.forEach(function (entry) {
                selected.push(entry.id);
            });
            $("#selected-poses").val(selected);
            $("select").material_select();

            $("textarea,input[type!=checkbox]").next("label").addClass("active");
            $("#add-index").openModal();
        },
        error: function (error) {
            console.log("Show edit modal error: " + error);
            Materialize.toast("Server error when u try to get available Index for edit!", 4000);
        }
    });
}

// Show delete modal
function showDeleteModal(id) {
    $("#delete-candidate-id").val(id);
    $("#delete-index").openModal();
}